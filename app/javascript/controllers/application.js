import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// Import and register all TailwindCSS Components or just the ones you need
import { Tabs } from "tailwindcss-stimulus-components"
import CurrentUrlController from "./current_url_controller"
import DateRangePickerController from "./date_range_picker_controller"
import FileGeneratorController from "./file_generator_controller"
import FireworksController from "./fireworks_controller"
import TogglerController from "./toggler_controller"


application.register('tabs', Tabs)
application.register('current-url', CurrentUrlController)
application.register('date-range-picker', DateRangePickerController)
application.register('file-generator', FileGeneratorController)
application.register('fireworks', FireworksController)
application.register('toggler', TogglerController)


export { application }
