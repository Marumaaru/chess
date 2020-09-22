# frozen_string_literal: true

# keeps all the eventual errors of legality check
module Errors
  def show_error(src, trg)
    invalid_move_check(src, trg) ||
      invalid_move(src, trg) ||
      invalid_path(src, trg) ||
      invalid_castling(src, trg)
  end

  def invalid_move_check(src, trg)
    return unless in_check?(src.color) || !getting_out_of_check?(src, trg)

    print display_error_invalid_move_check
  end

  def invalid_move(src, trg)
    return unless !valid_move?(src, trg) && !request_for_castling?(src, trg)

    print display_error_invalid_move(src)
  end

  def invalid_path(src, trg)
    return unless !path_free?(src, trg) && valid_move?(src, trg) && !request_for_castling?(src, trg)

    print display_error_invalid_path(src)
  end

  def invalid_castling(src, trg)
    return unless request_for_castling?(src, trg) && !castling_permissible?(trg)

    print display_error_invalid_castling
  end
end
