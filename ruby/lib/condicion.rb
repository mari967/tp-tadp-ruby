
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

