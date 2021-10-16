class MiClase
  def foo
  end

  def bar
  end
end

describe 'Condiciones' do

  describe 'Condición Selector' do

    it 'Filtro por método name fo{2} retorna array con un elemento' do
      resultado = []
      Aspects.on MiClase do
        resultado = where(name(/fo{2}/))
      end
      expect(resultado).to  eq [:foo]
    end

    it 'Filtro por método name fo{2} y foo retorna array con un elemento' do
      resultado = []
      Aspects.on MiClase do
        resultado = where name(/fo{2}/), name(/foo/)
      end
      expect(resultado).to eq ([:foo])
    end

    it 'Filtro por método name ^fi+ retorna array vacío' do
      listaResultado = []
      Aspects.on MiClase do
        listaResultado = where name(/^fi+/)
      end
      expect(listaResultado).to eq([])
    end

    it 'Filtro por método name ^fi+ retorna array vacío' do
      listaResultado = Aspects.on MiClase do where name(/foo/), name(/bar/) end
      expect(listaResultado).to eq([])
    end
  end

  describe 'Condición Cantidad de Parámetros' do
    class MiClase2
      def foo(p1, p2, p3, p4='a', p5='b', p6='c')
      end
      def bar(p1, p2='a', p3='b', p4='c')
      end
    end


    it 'Filtro para tres parámetros obligatorios de MiClase retorna foo' do
    lista_resultado = Aspects.on MiClase2 do
      where has_parameters(3, 'mandatory')
    end
    expect(lista_resultado).to eq([:foo])
    end

    it 'Filtro para seis parámetros cualesquiera de MiClase retorna foo' do
      lista_resultado = Aspects.on MiClase2 do
        where has_parameters(6)
      end
      expect(lista_resultado).to eq([:foo])
    end

    it 'Filtro para tres parámetros opcionales de MiClase retorna foo y bar' do
      lista_resultado = Aspects.on MiClase2 do
        where has_parameters(3, 'optional')
      end
      expect(lista_resultado).to eq([:foo, :bar])
    end
  end

  describe 'Condición nombre de parámetros' do
    class MiClase3
      def foo(param1, param2)
      end

      def bar(param1)
      end
    end

    it 'Filtro para métodos con un parámetro con nombre empezado en param retorna bar' do
      lista_resultado = Aspects.on MiClase3 do
        where has_parameters(1, /param.*/)
    end
      expect(lista_resultado).to eq([:bar])
    end

    it 'Filtro para métodos con dos parámetros con nombre empezado en param retorna foo' do
      lista_resultado = Aspects.on MiClase3 do
        where has_parameters(2, /param.*/)
      end
      expect(lista_resultado).to eq([:foo])
    end

    it 'Filtro para métodos con tres parámetros con nombre empezado en param no da resultados' do
      lista_resultado = Aspects.on MiClase3 do
        where has_parameters(3, /param.*/)
      end
      expect(lista_resultado).to eq([])
    end

  end


  describe 'Condición Negación' do
    class MiClase4
      def foo1(p1)
      end
      def foo2(p1, p2)
      end
      def foo3(p1, p2, p3)
      end
    end

    it 'Filtro para métodos con nombre /foo\d/ y que no tienen un parámetro retorna foo2 y foo3' do
      lista_resultado = Aspects.on MiClase4 do
        where name(/foo\d/), neg(has_parameters(1))
      end
      expect(lista_resultado).to eq([:foo2, :foo3])
    end
  end
end
