local question = {}

local questions = {}

function question.define(name, collector)
  questions[name] = {
    collector = collector,
    answers = {},
  }
end

function question.ask(name, ...)
  local collector = questions[name].collector
  local res

    for i, v in ipairs(questions[name].answers) do
    if i == 1 then
      res = v(...)
    else
      res = collector(res, v(...))
    end
  end

  return res
end

function question.answer(name, fn)
  table.insert(questions[name].answers, fn)
end

return question
