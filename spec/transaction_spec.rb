require 'spec_helper'

RSpec.describe Transaction do
  before do
    Transaction.clear!
  end

  describe '#self.define' do
    before do
      Transaction.define :test do
        define_step -> {}
      end
    end

    it 'defines a transaction' do
      expect(Transaction::REPOSITORY.length).to eq 1
      expect(Transaction::REPOSITORY.values.first).to be_a Array
      expect(Transaction::REPOSITORY.values.first.length).to eq 1
      expect(Transaction::REPOSITORY.values.first.first).to be_a Proc
    end
  end

  describe '#self.get' do
    context 'when the transaction is defined' do
      before do
        Transaction.define :test do
          define_step -> {}
        end
      end

      it 'gets a transaction' do
        expect(Transaction.get(:test)).to be_a Array
        expect(Transaction.get(:test).length).to eq 1
        expect(Transaction.get(:test).first).to be_a Proc
      end
    end

    context 'when the transaction is not defined' do
      it 'throws an error' do
        expect{ Transaction.get(:test) }.to raise_error(StandardError, 'unregistered transaction: test')
      end
    end
  end
end
