StarlingPunk
============

###Update Version 1.1 Change Log
 * Tilemap support
 * Ogmo editor intergration
 * Collision Mask support
 * Grid collision
 * Pixel Mask collision
 * Fixed bug with type only getting set when pass through entity constructor
 * added support for entity depth layers
 * added collideTypes method to entity class
 * misc bug fixes/performance improvements

##Future release plans:
 * Port Camera class
 * Extension for box2D Physics Library
 * Component based behavior system sorta like Unity3D
 * Helper functions for sound effects


Check out the examples that come with StarlingPunk:
http://andysaia.com/blog/starlingPunkTilemaps/starlingPunk-example.html

----------------------------------------------------------------

StarlingPunk is a framework built on top the Starling library designed to add structure and organization to your 2D game projects. It’s perfect for rapidly prototyping ideas and promotes code reuse between projects.  As you may have been able to tell from the name, StarlingPunk is heavily inspired by the popular FlashPunk framework, although its not a direct port.


### Why StarlingPunk:
* Easily encapsulate code into worlds and entities
* Manages collections of entities based on assigned types
* Fast and easy collision detection system
* All the power of starling performance, sprite sheets, particles, mobile development

### Why build this on top of Starling:
* Best of both worlds allowing us to mix and match regular Starling code with FlashPunk like organization. 
* Fast Stage3D hardware accelerated graphics
* Provides a familiar structure for Actionscript developers
* Harness the power of the display-list, worlds and entities extend the starling sprite class meaning display objects can be nested within them
* Pre-existing Starling code can easily be incorporated into the framework
* Starling already does a ton of things right, sprite-sheet animation, events, dynamic resolutions
* Tons of tools and extensions will already work, like sprite-manager and particles

### Planned future releases:
* Integration with the box2D physics library
* Helper class for the Ogmo level editor
* Helper functions for sound effects
* Component based behavior system sorta like Unity3D