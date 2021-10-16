require_relative 'condicion'
require_relative 'transformación'

class AspectForOrigin
  include Condicion
  include Transformacion

  attr_accessor :origen, :metodos_por_filtrar

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