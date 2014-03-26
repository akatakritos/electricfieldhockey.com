def level_json(n)
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

FactoryGirl.define do
  factory :user do 
    sequence :email do |n|
      "email#{n}@example.com"
    end
    sequence :name do |n|
      "Person #{n}"
    end
    sequence :created_at do |n|
      Time.now - (24*60*60*n)
    end
    sequence(:username) { |n| "user#{n}" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin_user do
      admin true
    end
  end


  factory :level do |n|
    sequence :name do |n|
      "Level #{n}"
    end

    sequence :json do |n|
      level_json(n)
    end

    association :creator, :factory => :user
  end

  factory :level_win do |n|
    sequence :level_json do |n|
      level_json(n).to_json
    end

    sequence :game_state do |n|
      "Game State #{n}"
    end

    sequence(:attempts) { |n| n }
    sequence(:time) { |n| rand(60) }

    association :level
    association :user
  end
end
