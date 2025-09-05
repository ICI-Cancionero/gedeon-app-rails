// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js or *_controller.ts.

import { Application } from '@hotwired/stimulus';

// Start the Stimulus application
const application = Application.start();

// Import and register all controllers here
import LetterNavController from "./letter_nav_controller";

// Configure Stimulus development experience
application.debug = process.env.NODE_ENV === 'development';

// Register controllers
application.register("letter-nav", LetterNavController);

export default application;
