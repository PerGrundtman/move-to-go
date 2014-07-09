require "spec_helper"
require 'fruit_to_lime'

describe "DealStatusReference" do
    let(:deal_status_reference){
        FruitToLime::DealStatusReference.new
    }

    it "should fail on validation if name, id and integration_id is nil" do
        # given
        #deal_status_reference

        # when, then
        deal_status_reference.validate.length.should be > 0
    end
end
