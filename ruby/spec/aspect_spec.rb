describe Aspects do


  describe 'Se puede definir Aspectos para orígenes' do
    let(:aspecto) { Aspects.new } #Con let en cada ejemplo, se llama al método.
    unBLoque = proc {}
    let(:MiClase) { Class.new}
    let(:MiModule) {Module.new}
    let(:MiOtroModule) {Module.new}
    let(:miObjeto) { $miObjeto = Object.new}

    it 'Entiende on' do  #Define un ejemplo (un test)
      expect(Aspects).to respond_to :on
    end

    it 'Aspectc.on funciona con una clase' do
      expect do Aspects.on MiClase &unBLoque end
      not raise_error
    end

    it 'Aspectc.on funciona con un módulo' do
      expect do Aspects.on MiModule &unBLoque end
      not raise_error
      end

    it 'Aspectc.on funciona con un objeto' do
      expect do Aspects.on miObjeto &unBLoque end
      not raise_error
    end

    it 'Aspectc.on funciona con diferentes origenes a la vez' do
      expect do Aspects.on miObjeto, MiClase,MiModule, MiOtroModule , &unBLoque end
      not raise_error
    end

    it 'Aspectc.on funciona con expresiones regulares' do
      expect { Aspects.on MiClase, /^Foo.*/, /.*bar/, &unBLoque }.not_to raise_error
    end
  end

  describe 'No se puede definir aspectos para orígenes vacíos' do
    let(:ClaseFalsa) {}
    it 'Aspectc.on falla sin un origen' do
      expect { Aspects.on }.to raise_error ArgumentError
    end

    it 'Aspectc.on falla con un origen inexistente falla' do
      expect { Aspects.on ClaseFalsa}.to raise_error ArgumentError
    end
  end

end