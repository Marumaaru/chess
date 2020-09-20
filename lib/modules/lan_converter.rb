# frozen_string_literal: true

module LanConverter
  def starting_rank_coords(input)
    rank_coord(split_lan(input).first)
  end

  def starting_file_coords(input)
    file_coord(split_lan(input).first)
  end

  def ending_rank_coords(input)
    rank_coord(split_lan(input).last)
  end

  def ending_file_coords(input)
    file_coord(split_lan(input).last)
  end

  def split_lan(input)
    input.downcase.scan(/[a-z][1-8]/)
  end

  def rank_coord(input)
    board.board.size - input.split('').last.to_i
  end

  def file_coord(input)
    (input.split('').first.ord - 49).chr.to_i
  end
end
