require 'rails_helper'

RSpec.describe UserService, type: :service do
  describe '#available_qualities' do
    context 'when user hasnot any cards' do
      it 'should return empty array' do
      end
    end
    context 'when user has cards' do
      it 'should return array of availables qualities' do
      end
    end
  end
end