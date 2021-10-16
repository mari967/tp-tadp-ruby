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
      cumple = false
      origen_to_filter = if @origen.is_a? Module
                           @origen.new
                         else @origen
                         end

      lista = origen_to_filter.methods
      metodo = origen_to_filter.method(method_to_filter)
      lista_parametros = origen_to_filter.method(method_to_filter).parameters
      if !tipo.nil?
        obligatoriedad = case tipo
                         when 'mandatory'
                           :req
                         when 'optional'
                           :opt
                         end
        cumple = lista_parametros.select do |lista_parametro|
                                          lista_parametro[0] == obligatoriedad end .size == cantidad

      else
        cumple = lista_parametros.size == cantidad
      end
      cumple
    end
  end

  def neg condicion

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