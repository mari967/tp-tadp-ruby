require_relative 'aspectsForOrigin'

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
