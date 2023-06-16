FactoryBot.define do
  factory :card_type do
    name { 'Premium' }
    start_points { 100 }
    emission { true }

    after :build do |card_type|
      card_type.icon.attach(
        io: Rails.root.join('spec', 'support', 'images', 'premium.svg').open,
        filename: 'premium.svg',
        content_type: 'image/svg+xml'
      )
    end
  end
end
