require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
    
  end
  
  
  test "product price must be positive" do
    product = Product.new(:title    => "My book title.",
                          :description => "My description.",
                          :image_url   => "MyImage.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')
    
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')
        
    product.price = 1
    assert product.valid?
    
  end
  
  
  def new_product(image_url)
    Product.new(:title    => "My book title.",
                :description => "My description.",
                :price => 1,
                :image_url   => image_url)
  end
  
  test "image url" do 
    ok = %w{ fred.gif fred.jpg fred.png FRED.GIF FRED.Jpg
           htt://abc.com/its/michael.gif }
    bad= %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      assert new_product(name).valid? "#{name} should'nt be invalid"
    end
    
    bad.each do |name|
      assert new_product(name).invalid? "#{name} should'nt be valid"
    end           
  end
  
  test "product title is at least 10 characters long" do
    product = Product.new(:title       => 'abc',
                          :description => "My description.",
                          :price       => 1,
                          :image_url   => 'fred.png')           
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
                 product.errors[:price].join('; ')
  end
  
  test "product is not valid without a unique title" do
    product = Product.new(:title       => "abc",
                          :description => "My description.",
                          :price       => 1,
                          :image_url   => 'fred.png') 
    assert !product.save
    assert_equal 'has already been taken', product.errors[:title].join('; ')
  end
  
  
  test "product is not valid without a unique title - i18n" do
    product = Product.new(:title    => products(:ruby).title,
                          :description => "My description.",
                          :price => 1,
                          :image_url   => 'fred.jpg')
                
    assert !product.save  
    assert_equal I18n.translate('activerecord.errors.messages.taken'),
                 product.errors[:title].join('; ')
               
    end
end
