defmodule BreakbenchWeb.VueView do
  use Phoenix.View, root: "lib/breakbench_web",
                    path: "vue",
                    namespace: BreakbenchWeb

  use Phoenix.HTML

  import BreakbenchWeb.Router.Helpers
  import BreakbenchWeb.ErrorHelpers
  import BreakbenchWeb.Gettext
end
