class Aspects
  def initialize
    @origenes = []
  end

  def self.origenes_inexistentes?(origenes)
    (origenes & ObjectSpace.each_object(Module).to_a).empty?
  end

  def self.on(*origenes, &bloque)
    raise ArgumentError.new "wrong number of arguments (0 for +1)" if origenes.empty?
    raise ArgumentError.new "origen vacío" if origenes_inexistentes?(origenes)
    origenes.map { |origen| AspectForOrigin.new(origen).instance_exec(&bloque) }.flatten(1)
    #Cuando el resultado era vacío, retornaba [[]]. FLatten es para ese caso. En otro no afecta
  end

end

module Condicion #cada condicion debe retornar un proc. El proc retorna un booleano
  def name(regex)
    proc do |method|
      regex.match? method
    end
  end

  def has_parameters cantidad, tipo=nil
    proc do |method_to_filter|
      origen_to_filter = if @origen.is_a? Module
                           @origen.new
                         else @origen
                         end

      lista_parametros = origen_to_filter.method(method_to_filter).parameters
      parametros_filtrados = if tipo.is_a? Regexp
                               lista_parametros.select { |lista_param| !lista_param[1].nil? and lista_param[1].match? tipo }
                             else
                               obligatoriedad = case tipo
                                                when 'mandatory'
                                                  :req
                                                when 'optional'
                                                  :opt
                                                end
                               lista_parametros.select { |lista_param| lista_param[0] == obligatoriedad || tipo.nil? }
                             end

      parametros_filtrados.size == cantidad
    end
  end

  def neg(condicion)
    proc { |method_to_filter| !condicion.call(method_to_filter) }
  end
end


class AspectForOrigin
  include Condicion
  attr_accessor :origen
  attr_accessor :metodos_por_filtrar

  def initialize origen
    @origen = origen
    @metodos_por_filtrar = if @origen.is_a? Module
                             @origen.instance_methods
                           else origen.methods
                           end
  end

  def where *condiciones
    #methods en clases y módulos no funciona. Incluye los métodos hasta object
    # Las clases y los módulos heradan de object por otro camino
    @metodos_por_filtrar.select { |method| condiciones.all? { |condicion| condicion.call(method) } }
  end

end