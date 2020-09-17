module Colorable
  def black(text);            "\e[30m#{text}\e[0m" end
  def red(text);              "\e[31m#{text}\e[0m" end
  def green(text);            "\e[32m#{text}\e[0m" end
  def orange(text);           "\e[33m#{text}\e[0m" end
  def blue(text);             "\e[34m#{text}\e[0m" end
  def magenta(text);          "\e[35m#{text}\e[0m" end
  def cyan(text);             "\e[36m#{text}\e[0m" end
  def gray(text);             "\e[37m#{text}\e[0m" end

  def bg_black(text);         "\e[40m#{text}\e[0m" end
  def bg_red(text);           "\e[41m#{text}\e[0m" end
  def bg_green(text);         "\e[42m#{text}\e[0m" end
  def bg_orange(text);        "\e[43m#{text}\e[0m" end
  def bg_blue(text);          "\e[44m#{text}\e[0m" end
  def bg_magenta(text);       "\e[45m#{text}\e[0m" end
  def bg_cyan(text);          "\e[46m#{text}\e[0m" end
  def bg_gray(text);          "\e[47m#{text}\e[0m" end

  def black_on_lt_blue(text); "\e[30;104m#{text}\e[0m" end
  def black_on_gray(text);    "\e[30;47m#{text}\e[0m" end
  
  def underline(text);        "\e[4;1m#{text}\e[0m" end
  def bold(text);             "\e[1;1m#{text}\e[0m" end
  def italic(text);           "\e[3m#{text}\e[23m" end
  def reverse_color(text);    "\e[7m#{text}\e[27m" end
end