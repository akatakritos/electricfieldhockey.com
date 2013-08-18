FactoryGirl.define do
  factory :user do 
    sequence :email do |n|
      "email#{n}@example.com"
    end
    sequence :name do |n|
      "Person #{n}"
    end
    sequence(:username) { |n| "user#{n}" }
    password "foobar"
    password_confirmation "foobar"
  end

  factory :level do |n|
    sequence :name do |n|
      "Level #{n}"
    end

    sequence :json do |n|
      {
        "name" => "Level #{n}",
        "width" => 800,
        "height" => 450,
        "goal" => {
          "x" => 775,
          "y" => 175,
          "width" => 25,
          "height" => 100
        },
        "backgroundUrl" => "",
        "puckPosition" => {
          "x"  => 100,
          "y" => 50
        },
        "startingCharges" => '1,-1,1,-1,1,-1'
      }
    end

    association :creator, :factory => :user
  end
end