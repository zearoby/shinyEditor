function createStatusBar(editor, el) {
   const statusbar_div = document.createElement('div');
   statusbar_div.id = el.id + "_statusBar";
   statusbar_div.style.display = "flex";
   statusbar_div.style.flexDirection = "row";
   statusbar_div.style.gap = "1px";

   const selection_div = document.createElement('div');
   selection_div.style.flex = 1;
   selection_div.id = el.id + "_selection_info";
   const StatusBar = ace.require("ace/ext/statusbar").StatusBar;
   const statusBar = new StatusBar(editor, selection_div);
   statusbar_div.appendChild(selection_div);

   ace.require('ace/ext/settings_menu').init(editor);
   const setting_btn = document.createElement('button');
   setting_btn.textContent = "Setting";
   setting_btn.onclick = function(event) {
      editor.showSettingsMenu();
   }
   statusbar_div.appendChild(setting_btn);
   return statusbar_div;
}

function initShinyEvent(editor, el) {
   if (HTMLWidgets.shinyMode) {
      editor.session.on("change", function(e) {
         Shiny.setInputValue(
            el.id, editor.getValue(), {priority: "event"}
         );
         Shiny.setInputValue(
            el.id + "_changed",
            JSON.stringify({
               action: e.action,
               start:  e.start,
               end:    e.end,
               lines:  e.lines,
               value:  editor.getValue()
            }),
            {priority: "event"}
         );
      });
      editor.session.selection.on("changeCursor", function() {
         const pos = editor.selection.getCursor();
         Shiny.setInputValue(
            el.id + "_cursor_changed",
            JSON.stringify(pos),
            {priority: "event"}
         );
      });
      editor.session.selection.on("changeSelection", function(e) {
         const range = editor.selection.getRange();
         Shiny.setInputValue(
            el.id + "_selection_changed",
            JSON.stringify({
               row_start:    range.start.row,
               row_end:      range.end.row,
               column_start: range.start.column,
               column_end:   range.end.column,
            }),
            {priority: "event"}
         );
         Shiny.setInputValue(
            el.id + "_selected_text",
            editor.getSelectedText(),
            {priority: "event"}
         );
      });
   }

   if (HTMLWidgets.shinyMode) {
      Shiny.setInputValue(el.id + "_ready", true, {priority: "event"});
   }
}

function initialAceEditor(el, x) {
   el.innerHTML = "";
   const el_id = el.id;
   el.id = el_id + "_parent";
   el.style.display = "flex";
   el.style.flexDirection = "column";
   const editor_container = document.createElement("div");
   editor_container.id = el_id;
   editor_container.style.display = "flex";
   editor_container.style.flex = 1;
   el.append(editor_container);

   const editor = ace.edit(editor_container);
   initShinyEvent(editor, editor_container);
   let unrecognized_arguments = [];
   for (const key in x) {
      if (aceOptionKeys.includes(key)) {
         editor.setOption(key, x[key])
      }
      else if (key == "showStatusBar") {
         if (x.showStatusBar == true) {
            el.append(createStatusBar(editor, editor_container));
         }
      }
      else {
         if (key == "enableSpellCheck") {
            editor.enableSpellCheck = x[key];
            continue;
         }
         else {
            unrecognized_arguments.push(key);
         }
         console.warn(`Unrecognized argument: "${key}"`);
      }
   }
   if (unrecognized_arguments.length > 0) {
      console.warn(`Unrecognized arguments: ${unrecognized_arguments.join(", ")}.`);
      console.warn("For unrecognized arguments, please refer to https://ace.c9.io/api/interfaces/ace.Ace.EditorOptions.html");
   }
   editor.spellChecker = new AceSpellChecker(editor);
   editor.focus();
   return editor;
}

function initialAceDiffEditor(el, x, type) {
   let y = { ...x };
   y["value"] = type === "a" ? y.valueA : y.valueB;
   delete y.valueA;
   delete y.valueB;
   return initialAceEditor(el, y);
}

var aceOptionKeys = [
   // Editor options
   "selectionStyle",
   "highlightActiveLine",
   "highlightSelectedWord",
   "readOnly",
   "cursorStyle",
   "mergeUndoDeltas",
   "behavioursEnabled",
   "wrapBehavioursEnabled",
   "autoScrollEditorIntoView",
   "copyWithEmptySelection",
   "enableMultiselect",
   "enableAutoIndent",
   "enableKeyboardAccessibility",
   "enableBasicAutocompletion",
   "enableLiveAutocompletion",
   "enableSnippets",
   "enableCodeLens",
   "enableMobileMenu",
   "navigateWithinSoftTabs",
   "placeholder",
   "relativeLineNumbers",
   "keyboardHandler",
   "value",

   // Renderer options
   "hScrollBarAlwaysVisible",
   "vScrollBarAlwaysVisible",
   "highlightGutterLine",
   "animatedScroll",
   "showInvisibles",
   "showPrintMargin",
   "printMarginColumn",
   "printMargin",
   "fadeFoldWidgets",
   "showFoldWidgets",
   "showLineNumbers",
   "showGutter",
   "displayIndentGuides",
   "highlightIndentGuides",
   "fontSize",
   "fontFamily",
   "maxLines",
   "minLines",
   "scrollPastEnd",
   "fixedWidthGutter",
   "theme",
   "customScrollbar",
   "hasCssTransforms",
   "maxPixelHeight",
   "useSvgGutterIcons",
   "useResizeObserver",
   "tooltipFollowsMouse",

   // Session options
   "firstLineNumber",
   "overwrite",
   "newLineMode",
   "useWorker",
   "useSoftTabs",
   "indentedSoftWrap",
   "tabSize",
   "wrap",
   "wrapMethod",
   "foldStyle",
   "mode",

   // Mouse handler options
   "scrollSpeed",
   "dragDelay",
   "dragEnabled",
   "focusTimeout"
];
