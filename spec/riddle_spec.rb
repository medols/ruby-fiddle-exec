require File.expand_path('../spec_helper', __FILE__)

describe Riddle do

  it "should be able to extend string" do
    palindrome_code=<<EORUBY
      class String
        def palindrome?
          self.reverse == self
        end
      end
      "yoy".palindrome?
EORUBY
    subject.execute(palindrome_code).result.should be_true
  end

  it "should give me the result" do
    subject.execute("1+1").result.should eq(2)
  end

  it "should give me the result" do
    subject.execute("proc{4}*4").result.should eq([4, 4, 4, 4])
  end

  it "should capture the output in an array of lines" do
    subject.execute("puts 'oh hai'; puts 'yo there'")
    subject.output.should eq(["oh hai", "yo there"])
  end

  it "should not actually exception" do
    expect {
      subject.execute("raise StandardError.new('yo there')")
    }.to_not raise_error
  end

  it "should store off the exception to exception" do
    subject.execute("1/0")
    ex = subject.exception
    ex.should eq("ZeroDivisionError: divided by 0")
  end

  it "shouldn't throw a syntax error" do
    expect {
      subject.execute("1+{")
    }.to_not raise_error
  end

	it "shouldn't exception on a load error" do
    expect {
      subject.execute("require 'nopers'; puts 'nopers'")
    }.to_not raise_error
	end

end
