require "spec_helper"

describe Auther::FoundationHelper, :type => :helper do
  describe "#render_foundation_error" do
    it "renders error class when enabled" do
      result = render_foundation_error true
      expect(result).to eq("error")
    end

    it "renders an empty string when disabled" do
      result = render_foundation_error false
      expect(result).to eq('')
    end

    it "renders classes with error class suffix" do
      result = render_foundation_error true, classes: %w(one two)
      expect(result).to eq("one two error")
    end

    it "renders classes without an error class suffix" do
      result = render_foundation_error false, classes: %w(one two)
      expect(result).to eq("one two")
    end
  end
end
