import IEx.Helpers

alias ToDoodleDo.Accounts
alias ToDoodleDo.Planner
alias ToDoodleDo.Repo
alias ToDoodleDoWeb.Endpoint

IEx.configure(
  default_prompt: "%prefix:%counter>",
  alive_prompt: "%prefix(%node):%counter>",
  history_size: -1,
  colors: [
    eval_result: [:yellow, :bright]
  ]
)

import_if_available(Ecto.Query)
