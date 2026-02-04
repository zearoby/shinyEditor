// The code refer to https://github.com/swenson/ace_spellCheck_js/blob/master/spellcheck_ace.js

// initialize Typo.js dict object
var dictionary = new Typo("en_US", en_US_aff, en_US_dic);



(function() {
   class AceSpellChecker {
      constructor(editor) {
         this.editor = editor;
         this.lang = "en_US";
         this.contents_modified = true;
         this.currently_spellchecking = false;
         this.markers_present = [];

         if (editor.enableSpellCheck == true) {
            this.enableSpellCheck();
         }
      }

      // Check the spelling of a line, and return [start, end]-pairs for misspelled words.
      misspelled(line) {
         const words = line.split(/[\W\d]/);
         let i = 0;
         let bads = [];
         for (const word in words) {
             const x = words[word] + "";
             const camelCaseWords = x.match(/[a-z]+|[A-Z][a-z]*/g) || [x];
             for (const checkWord of camelCaseWords) {
                 if (checkWord.length > 0 && !dictionary.check(checkWord)) {
                     bads[bads.length] = [i, i + checkWord.length];
                 }
                 i += checkWord.length;
             }
             i += 1;
         }

         return bads;
      }

      // Spell check the Ace editor contents.
      spellCheck() {
        // Wait for the dictionary to be loaded.
         if (dictionary == null) {
            return;
         }

         if (this.currently_spellchecking) {
            return;
         }

         if (!this.contents_modified) {
             return;
         }
         this.currently_spellchecking = true;
         const session = this.editor.getSession();

         // Clear all markers and gutter
         this.clearSpellcheckMarkers();
         // Populate with markers and gutter
        try {
            const Range = ace.require('ace/range').Range
            const lines = session.getDocument().getAllLines();
            for (const i in lines) {
               // Check spelling of this line.
               const misspellings = this.misspelled(lines[i]);

               // Add markers and gutter markings.
               if (misspellings.length > 0) {
                  session.addGutterDecoration(i, "misspelled");
               }
               for (const j in misspellings) {
                  const range = new Range(i, misspellings[j][0], i, misspellings[j][1]);
                  this.markers_present[this.markers_present.length] = session.addMarker(range, "misspelled", "typo", true);
               }
            }
         } finally {
            this.currently_spellchecking = false;
            this.contents_modified = false;
         }
      }

      enableSpellCheck() {
         this.editor.enableSpellCheck = true;
         this.editor.session.on("change", function(e) {
            if (this.editor.enableSpellCheck) {
               this.contents_modified = true;
               this.spellCheck();
            };
         }.bind(this));
         // needed to trigger update once without input
         this.contents_modified = true;
         this.spellCheck();
      }

      disableSpellCheck() {
         this.editor.enableSpellCheck = false
         // Clear the markers
         this.clearSpellcheckMarkers();
      }

      clearSpellcheckMarkers() {
         const session = this.editor.getSession();
         for (const i in this.markers_present) {
            session.removeMarker(this.markers_present[i]);
         };
         this.markers_present = [];
         // Clear the gutter
         const lines = session.getDocument().getAllLines();
         for (const i in lines) {
            session.removeGutterDecoration(i, "misspelled");
         };
      }

      suggest_word_for_misspelled(misspelledWord) {
         const is_spelled_correctly = dictionary.check(misspelledWord);

         const array_of_suggestions = dictionary.suggest(misspelledWord);
         if (is_spelled_correctly || array_of_suggestions.length === 0) { return false }
         return array_of_suggestions
      }
   }
   window.AceSpellChecker = AceSpellChecker;
})();
