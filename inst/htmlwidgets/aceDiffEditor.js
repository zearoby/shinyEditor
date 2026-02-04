HTMLWidgets.widget({
   name: 'aceDiffEditor',
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
            inline_checkbox.title = "Show aceDiffEditor in split view or inline view";
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

            const diff_editor_container = document.createElement("div");
            diff_editor_container.style.display = "flex";
            diff_editor_container.style.flex = 1;
            el.append(tool_bar, diff_editor_container);

            const editor_a_div = document.createElement("div");
            editor_a_div.id = el.id + "-a";
            editor_a_div.style.flex = 1;
            divider = document.createElement("div");
            divider.classList.add('diff-editor-divider');
            divider.style.width = "6px";
            const editor_b_div = document.createElement("div");
            editor_b_div.id = el.id + "-b";
            editor_b_div.style.width = "50%";
            diff_editor_container.append(editor_a_div, divider, editor_b_div);

            const editorA = initialAceDiffEditor(editor_a_div, x, "a");
            const editorB = initialAceDiffEditor(editor_b_div, x, "b");

            const {DiffProvider, InlineDiffView, SplitDiffView, createDiffView} = ace.require('ace/ext/diff');
            let diffEditor = null;

            let dragging = false;
            divider.addEventListener('mousedown', function(e) {
               dragging = true;
            });
            document.addEventListener('mousemove', function(e) {
               if (!dragging) return;
               editor_a_div.style.width = e.clientX + 'px';
            });
            document.addEventListener('mouseup', function() {dragging = false;});
            divider.addEventListener('dblclick', () => {editor_a_div.style.width = "50%";});

            go_previous_btn.addEventListener('click', () => {
               diffEditor.gotoNext(diffEditor.firstDiffSelected() ? diffEditor.chunks.length - 1 : -1)
               status_label.textContent = `${diffEditor.currentDiffIndex}/${diffEditor.chunks.length}`;
            });
            go_next_btn.addEventListener('click', () => {
               diffEditor.gotoNext(diffEditor.lastDiffSelected() ? 1 - diffEditor.chunks.length: 1)
               status_label.textContent = `${diffEditor.currentDiffIndex}/${diffEditor.chunks.length}`;
            });

            function check_discrepancy_status() {
               diffEditor?.onInput();
               chunks_length = diffEditor.chunks.length;
               status_label.textContent = chunks_length === 0 ? "Congratulations!!! No discrepancy" : chunks_length;
            }

            inline_checkbox.addEventListener('change', () => {
               const inline = document.getElementById(el.id+"_inline_checkbox").checked;
               diffEditor?.detach();
               if (inline) {
                  diffEditor = new InlineDiffView({
                     editorA, editorB,
                     inline: "a"
                  });
               }
               else {
                  diffEditor = new SplitDiffView({
                     editorA, editorB,
                  });
               }
               editor_b_div.style.display = inline ? "none" : "flex";
               divider.style.display = inline ? "none" : "flex";
               diffEditor.setProvider(new DiffProvider());
               check_discrepancy_status();
            });

            ignore_spaces_checkbox.addEventListener('change', () => {
               const ignore_spaces = document.getElementById(el.id+"_ignore_spaces_checkbox").checked;
               diffEditor.setOption("ignoreTrimWhitespace", ignore_spaces);
               check_discrepancy_status();
            });

            wrap_line_checkbox.addEventListener('change', () => {
               const wrap_line = document.getElementById(el.id+"_wrap_line_checkbox").checked;
               diffEditor.setOption("wrap", wrap_line);
            });
            inline_checkbox.dispatchEvent(new Event('change'));

            editorA.session.on("change", function(e) {
               check_discrepancy_status();
            })

            editorB.session.on("change", function(e) {
               check_discrepancy_status();
            })
         },

         resize: function(width, height) {
            // TODO: code to re-render the widget with a new size
         }
      };
   }
});
