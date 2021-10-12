describe 'Condiciones' do
  class MiClase
    def foo
    end

    def bar
    end
  end


 it 'Filtro por método name fo{2} retorna array con un elemento' do
   expect { Aspects.on MiClase do
       where name(/fo{2}/)
     end }.should eq([:foo])
 end

  it 'Filtro por método name fo{2} y foo retorna array con un elemento' do
    expect { Aspects.on MiClase do
      where name(/fo{2}/), name(/foo/)
    end }.to match([:foo])
  end

  it 'Filtro por método name ^fi+ retorna array vacío' do
    listaResultado = Aspects.on MiClase do where name(/^fi+/) end
    expect(listaResultado).to be_empty
  end

  it 'Filtro por método name ^fi+ retorna array vacío' do
    listaResultado = Aspects.on MiClase do where name(/foo/), name(/bar/) end
    expect(listaResultado).to be_empty
  end
end
