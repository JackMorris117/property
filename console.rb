require('pry-byebug')
require_relative('models/property_tracker')

property1 = PropertyTracker.new({
    'address' => '10 Hudson Close',
    'value' => 350000,
    'year_built' => 1980,
    'build' => 'detached'
})

property2 = PropertyTracker.new({
    'address' => '8 Salamander Court',
    'value' => 200000,
    'year_built' => 2007,
    'build' => 'flat'
})

binding.pry

nil