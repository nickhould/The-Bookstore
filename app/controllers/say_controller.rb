class SayController < ApplicationController

attr_accessor :time

  def hello
   @time = Time.now
   @files = Dir.glob('*')
  end

  def goodbye
    @time = Time.now
  end

end
