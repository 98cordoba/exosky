# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "three", to: "vendors/three.module.js"
pin "stats", to: "vendors/stats.module.js"
pin "FlyControls", to: "vendors/controls/FlyControls.js"
pin "Lensflare", to: "vendors/objects/Lensflare.js"
pin "OrbitControls", to: "vendors/controls/OrbitControls.js"
