class Aspects
  attr_accessor
  def initialize
    @origenes =[]
  end

  def self.on(*origenes, &bloque)
    raise ArgumentError.new "wrong number of arguments (0 for +1)" if origenes.empty?
    raise ArgumentError.new "origen vacío" if origenesInexistentes(origenes)
    @origenes += origenes

  end

  def origenesInexistentes(*origenes)
       origenes & ObjectSpace.each_object(Module).to_a.empty?
  end

  def where *condiciones #DEeb existir un where general y uno individual para cada origen,
    # para que filtren sus propios métodos
    #retorna el resultado de aplicar condiciones a cada origen
    # Las condiciones son alias, para llamar al método correspondiente en cada origen
    # Lista
  end
end

module Condicion #cada condicion debe retornar un proc
  def name(regex)
    proc do |method|
      regex.match? method
    end
  end

  def has_parameters cantidad, tipo=all, regexNombreParametros=/.*/

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
    @metodos_por_filtrar = origen.methods
  end

  def where *condiciones
    @origen.methods.select { |method| condiciones.all? { |condicion| condicion.call(method)} }
  end

end