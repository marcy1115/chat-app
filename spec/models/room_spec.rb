require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "#create" do
    before do
      @room = FactoryBot.build( :room )
    end

    it "nameの値が存在すれば登録できる事" do
      expect( @room ).to be_valid
    end
    
    it "nameが空では登録出来ない事" do
      @room.name = nil
      @room.valid?
      expect( @room.errors.full_messages ).to include( "Name can't be blank" )
    end
  end
end