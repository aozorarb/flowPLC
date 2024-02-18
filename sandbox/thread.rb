t1 = false
t2 = false

Thread.new do |th|
  t2 = false
  while true
    if t1 == true
      t2 = true
      puts "t1 is true"
    else
      puts "please!"
    end
    sleep 1
  end
end

sleep 2
t1 = true
sleep 10
