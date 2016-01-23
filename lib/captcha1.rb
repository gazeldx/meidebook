require 'subexec'

class Captcha
  def self.create(code)
    command = <<-CODE
      convert -size 100x28 -fill black -background white \
      -draw 'stroke black line #{rand(20)},#{rand(28)} #{rand(30)+50},#{rand(28)}' \
      -draw 'stroke black line #{rand(50)},#{rand(28)} #{rand(100)},#{rand(28)}' \
      -wave #{2+rand(2)}x#{50+rand(20)} \
      -font '#{Sinatra::Application.settings.root}/public/fonts/SegoePro-Regular.ttf' \
      -gravity Center -sketch 3x1+#{rand(180)} -pointsize 22 -implode 0.2 label:#{code} png:-
    CODE
    sub = Subexec.run(command)
    sub.output
  end

  def self.valid_chars
    [('0'..'9')].map { |i| i.to_a }.flatten - ['0', '1', 'l', 'o', 'O', 'I']
  end

  def self.random_text
    (0...4).map { valid_chars[rand(valid_chars.length)] }.join
  end
end
