HTMLWidgets.widget({
   name: 'aceEditor',
   type: 'output',
   factory: function(el, width, height) {
      // TODO: define shared variables for this instance
      return {
         renderValue: function(x) {
            // TODO: code to render the widget, e.g.
            const editor = initialAceEditor(el, x);
         },

         resize: function(width, height) {
            // TODO: code to re-render the widget with a new size
         }
      };
   }
});
