HTMLWidgets.widget({
   name: 'monacoDiffEditor',
   type: 'output',
   factory: function(el, width, height) {
      // TODO: define shared variables for this instance
      return {
         renderValue: function(x) {
            el.innerHTML = "";
            el.style.display = "flex";
            el.style.flexDirection = "column";

            const tool_bar = document.createElement("div");
            tool_bar.style.display = "flex";
            tool_bar.style.gap = "6px";
            tool_bar.style.margin = "2px";
            tool_bar.style.paddingBottom = "2px";
            tool_bar.style.alignItems = "center";
            const inline_checkbox = document.createElement("div");
            inline_checkbox.innerHTML = `<label><input type="checkbox" id="${el.id}_inline_checkbox">Inline</label>`;
            inline_checkbox.title = "Show monacoDiffEditor in split view or inline view";
            const ignore_spaces_checkbox = document.createElement("div");
            ignore_spaces_checkbox.innerHTML = `<label><input type="checkbox" id="${el.id}_ignore_spaces_checkbox">Ignore Spaces</label>`;
            ignore_spaces_checkbox.title = "Ignore trim white space";
            const wrap_line_checkbox = document.createElement("div");
            wrap_line_checkbox.innerHTML = `<label><input type="checkbox" id="${el.id}_wrap_line_checkbox">Wrap Line</label>`;
            wrap_line_checkbox.title = "Wrap long line";
            const go_previous_btn = document.createElement("button");
            go_previous_btn.textContent = "↑";
            go_previous_btn.title = "Go to previous discrepancy";
            const go_next_btn = document.createElement("button");
            go_next_btn.textContent = "↓";
            go_next_btn.title = "Go to next discrepancy";
            const status_label = document.createElement('span');
            status_label.title = "The count of discrepancy";

            tool_bar.append(inline_checkbox, ignore_spaces_checkbox, wrap_line_checkbox, go_previous_btn, go_next_btn, status_label);
            el.appendChild(tool_bar);
            let diffEditor = null;


            function initDiffEditor() {
               const editorModelA = monaco.editor.createModel(x.valueA, x.language);
               const editorModelB = monaco.editor.createModel(x.valueB, x.language);

               delete x.valueA;
               delete x.valueB;
               delete x.language;

               const editor_setting = {};
               let unrecognized_arguments = [];

               for (const key in x) {
                  if (monacoDiffEditorOptions.includes(key)) {
                     editor_setting[key] = x[key];
                  }
                  else if (key !== "showStatusBar") {
                     unrecognized_arguments.push(key);
                  }
               }
               if (unrecognized_arguments.length > 0) {
                  console.warn(`Unrecognized arguments: ${unrecognized_arguments.join(", ")}.`);
                  console.warn("For unrecognized arguments, please refer to https://microsoft.github.io/monaco-editor/typedoc/interfaces/editor_editor_api.editor.IDiffEditorConstructionOptions.html");
               }

               diffEditor = monaco.editor.createDiffEditor(el, editor_setting);

               diffEditor.setModel({
                  original: editorModelA,
                  modified: editorModelB
               });
            }


            if (typeof monaco === "undefined") {
               require(['vs/editor/editor.main'], function () {
                  initDiffEditor();
               });
            }
            else {
               initDiffEditor();
            }

            inline_checkbox.addEventListener('change', () => {
               const inline = document.getElementById(el.id+"_inline_checkbox").checked;
               diffEditor.updateOptions({renderSideBySide: !inline});
            });

            ignore_spaces_checkbox.addEventListener('change', () => {
               const ignore_spaces = document.getElementById(el.id+"_ignore_spaces_checkbox").checked;
               diffEditor.updateOptions({"ignoreTrimWhitespace": ignore_spaces});
            });

            wrap_line_checkbox.addEventListener('change', () => {
               const wrap_line = document.getElementById(el.id+"_wrap_line_checkbox").checked;
               diffEditor.getOriginalEditor().updateOptions({"wordWrap": wrap_line ? "on":"off"});
               diffEditor.getModifiedEditor().updateOptions({"wordWrap": wrap_line ? "on":"off"});
            });

            go_previous_btn.addEventListener('click', () => {
               const modified = diffEditor.getModifiedEditor();
               modified.trigger('keyboard', 'editor.action.diffReview.prev', null);
            });
            go_next_btn.addEventListener('click', () => {
               const modified = diffEditor.getModifiedEditor();
               modified.trigger('keyboard', 'editor.action.diffReview.next', null);
            });

         },

         resize: function(width, height) {
            // TODO: code to re-render the widget with a new size
         }
      };
   }
});
