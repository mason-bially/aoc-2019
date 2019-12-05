Code.require_file("el.ex", __DIR__)


IO.inspect(Day04.count_password_possibilities(&Day04.A.valid_password/1, Day04.input_begin, 0))
