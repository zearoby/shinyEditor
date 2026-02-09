(function() {
   class MonacoSpellChecker {
      constructor(editor) {
         this.editor = editor;
         this.contents_modified = true;
         this.currently_spellchecking = false;
         this.decorationIds = [];

         this.dictionary = new Typo("en_US", en_US_aff, en_US_dic);

         if (editor.enableSpellCheck == true) {
            this.enableSpellCheck();
         }
      }

      misspelled(word) {
         return word.length > 0 && !this.dictionary.check(word);
      }

      // Spell check the Ace editor contents.
      spellCheck() {
         // Wait for the dictionary to be loaded.
         if (this.dictionary == null) {
            return;
         }
         if (this.currently_spellchecking) {
            return;
         }
         if (!this.contents_modified) {
             return;
         }
         this.currently_spellchecking = true;
         this.clearSpellcheckMarkers();

         const model = this.editor.getModel();
         if (!model) return;
         const visibleRanges = this.editor.getVisibleRanges();
         const lines = this.editor.getModel().getLineCount();
         const newDecorations = [];
         const WORD = /[a-z]+|[A-Z][a-z]*/g;

         for (let line = 1; line <= lines; line++) {
            const text = model.getLineContent(line);
            let m = null;
            while ((m = WORD.exec(text)) !== null) {
               const word = m[0];
               if (!this.misspelled(word)) continue;
               const startColumn = m.index + 1;
               const endColumn = startColumn + word.length;
               newDecorations.push({
                  range: new monaco.Range(line, startColumn, line, endColumn),
                  options: {
                     inlineClassName: "monaco_misspelled",
                     overviewRuler: {
                        color: 'orange',
                        darkColor: 'darkorange',
                        position: monaco.editor.OverviewRulerLane.Left
                     }
                  }
               });
            }
         }
         this.decorationIds = this.editor.deltaDecorations(this.decorationIds, newDecorations);

         this.currently_spellchecking = false;
         this.contents_modified = false;
      }

      enableSpellCheck() {
         this.editor.enableSpellCheck = true;
         this.editor.onDidChangeModelContent((event) => {
            if (this.editor.enableSpellCheck) {
               this.contents_modified = true;
               this.spellCheck();
            };
         });
         // needed to trigger update once without input
         this.contents_modified = true;
         this.spellCheck();
      }

      clearSpellcheckMarkers() {
         this.decorationIds = this.editor.deltaDecorations(this.decorationIds, []);
      }

      disableSpellCheck() {
         this.editor.enableSpellCheck = false
         // Clear the markers
         this.clearSpellcheckMarkers();
      }
   }
   window.MonacoSpellChecker = MonacoSpellChecker;
})();
