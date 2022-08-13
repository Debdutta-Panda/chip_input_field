import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.only(right: 150),
          child: Container(
            child: ChipInputField(
              autocomplete: true,
              fieldMinHeight: 60,
              fieldPadding: EdgeInsets.all(8),
              tagBuilder: (data,fnDelete)=>Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(data),
                  IconButton(
                      onPressed: (){
                        fnDelete(data);
                      },
                      icon: Icon(Icons.close
                      ))
                ],
              ),
              optionViewBuilder: (highlighted,index)=>Text(
                  index.toString(),
                style: TextStyle(
                  color: highlighted ? Colors.red : Colors.black
                ),
              ),
              optionListMaterialBuilder: (child,elevation)=>Material(
                color: Colors.green,
                elevation: elevation,
                child: child,
              )
          ),
          ),
        ),
      ),
    );
  }
}

class ChipInputField extends StatefulWidget {
  const ChipInputField(
      {
        this.autocomplete = false,
        this.fieldMinHeight = 60,
        this.fieldDecoration,
        this.fieldPadding = const EdgeInsets.all(8.0),
        this.spacing = 10,
        this.runSpacing = 10,
        this.tagBuilder,
        this.coreFieldMinWidth = 100,
        this.optionViewBuilder,
        this.optionListTopPadding = 16,
        this.optionListElevation = 4,
        this.optionListConstraints,
        this.optionListPadding = EdgeInsets.zero,
        this.optionListMaterialBuilder,
        this.optionBuilder = _defaultOptionBuilder,
        this.coreFieldHeight = 32,
        this.hint = "",
        this.textFieldWrapperBuilder,
        this.inputFormatters,
        required this.onTagAdded,
        required this.onTagDeleted,
        Key? key
      }
  ) : super(key: key);
  final bool autocomplete;
  final double fieldMinHeight;
  final BoxDecoration? fieldDecoration;
  final EdgeInsets fieldPadding;
  final double spacing;
  final double runSpacing;
  final Widget Function(dynamic,Function(dynamic))? tagBuilder;
  final double coreFieldMinWidth;
  final Widget Function(bool,int)? optionViewBuilder;
  final double optionListTopPadding;
  final double optionListElevation;
  final BoxConstraints? optionListConstraints;
  final EdgeInsets optionListPadding;
  final Material Function(Widget,double)? optionListMaterialBuilder;
  final Iterable<Object> Function(TextEditingValue) optionBuilder;
  final double coreFieldHeight;
  final String hint;
  final Widget Function(Widget)? textFieldWrapperBuilder;
  final List<TextInputFormatter>? inputFormatters;
  final Function(dynamic) onTagAdded;
  final Function(dynamic) onTagDeleted;
  @override
  State<ChipInputField> createState() => _ChipInputFieldState();

  static Iterable<Object> _defaultOptionBuilder(TextEditingValue value){
    return Iterable<Object>.empty();
  }
}

/*(TextEditingValue textEditingValue) {
if (textEditingValue.text == '') {
return const Iterable<String>.empty();
}
return _kOptions.where((String option) {
return option.contains(textEditingValue.text.toLowerCase());
});
}*/

class _ChipInputFieldState extends State<ChipInputField> {
  var focusNode = FocusNode();
  var controller = TextEditingController();
  List<dynamic> items = [];
  @override
  Widget build(BuildContext context) {
    return
    LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints)=>Container(
          child: GestureDetector(
            onTap: onTap,
            child: MouseRegion(
              cursor: SystemMouseCursors.text,
              child: Container(
                constraints: BoxConstraints(
                    minHeight: widget.fieldMinHeight
                ),
                decoration: widget.fieldDecoration ?? _defaultFieldDecoration(),
                child: Padding(
                  padding: widget.fieldPadding,
                  child: Wrap(
                    runSpacing: widget.runSpacing,
                    spacing: widget.spacing,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...items.map(
                              (e) => widget.tagBuilder?.call(e,onDelete)?? _defaultChipWidget(e)
                      ).toList(),
                      IntrinsicWidth(
                        child: Container(
                          constraints: BoxConstraints(
                              minWidth: widget.coreFieldMinWidth
                          ),
                          child: RawKeyboardListener(
                            focusNode: FocusNode(),
                            onKey: onKey,
                            child:
                            widget.autocomplete ?
                            AutocompleteWidget()
                            :(widget.textFieldWrapperBuilder?.call(TextFieldWidget()) ?? TextFieldWidget()),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );

  }

  Widget _defaultChipWidget(dynamic e){
    return Container(
      height: 32,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).colorScheme.secondary
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: IntrinsicWidth(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  e.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary
                  ),
                ),
              ),
              SizedBox(width: 8,),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: ()=>onDelete(e),
                  child: Icon(
                    color: Theme.of(context).colorScheme.onPrimary,
                    Icons.close,
                    size: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget AutocompleteWidget(){
    return Autocomplete<Object>(
      optionsViewBuilder: (
          BuildContext context,
          AutocompleteOnSelected<Object> onSelected,
          Iterable<Object> options
          ) {
        return
          Padding(
            padding: EdgeInsets.only(top: widget.optionListTopPadding),
            child: Align(
              alignment: Alignment.topLeft,
              child: widget.optionListMaterialBuilder?.call(optionListWidget(options,onSelected),widget.optionListElevation) ?? Material(
                elevation: widget.optionListElevation,
                child: optionListWidget(options,onSelected),
              ),
            ),
          );
      },
      optionsBuilder: widget.optionBuilder,
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode fn, VoidCallback onFieldSubmitted) {
        controller = textEditingController;
        focusNode = fn;
        return SizedBox(
          height: widget.coreFieldHeight,
          child: Center(
            child: widget.textFieldWrapperBuilder?.call(_defaultTextFormField(textEditingController,onFieldSubmitted,fn)) ??
                _defaultTextFormField(textEditingController,onFieldSubmitted,fn),
          ),
        );
      },
      onSelected: (dynamic selection) {
        onComma(selection);
      },
    );
  }

  Widget _defaultTextFormField(
      TextEditingController textEditingController,
      VoidCallback onFieldSubmitted,
      FocusNode fn
  ){
    return TextFormField(
        controller: textEditingController,
        decoration: InputDecoration.collapsed(
            hintText: widget.hint
        ),
        focusNode: fn,
        onFieldSubmitted: (String value) {
          onFieldSubmitted();
        },
        inputFormatters: widget.inputFormatters ?? [
          FilteringTextInputFormatter.allow(RegExp(r"[^,^\s]+[\s]?")),
        ]
    );
  }

  Widget optionListWidget(Iterable<Object> options, AutocompleteOnSelected<Object> onSelected){
    return ConstrainedBox(
      constraints: widget.optionListConstraints ?? _defaultOptionListConstraints(),
      child: ListView.builder(
        padding: widget.optionListPadding,
        shrinkWrap: true,
        itemCount: options.length,
        itemBuilder: (BuildContext context, int index) {
          final Object option = options.elementAt(index);
          return InkWell(
            onTap: () {
              onSelected(option);
            },
            child: Builder(
                builder: (BuildContext context) {
                  final bool highlight = AutocompleteHighlightedOption.of(context) == index;
                  if (highlight) {
                    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    });
                  }
                  return widget.optionViewBuilder?.call(highlight,index) ?? _defaultOptionWidget(highlight,index);
                }
            ),
          );
        },
      ),
    );
  }

  Widget _defaultOptionWidget(bool highlight, dynamic option){
    return Container(
      color: highlight ? Theme.of(context).focusColor : null,
      padding: const EdgeInsets.all(16.0),
      child: Text(option.toString()),
    );
  }

  void onTap(){
    focusNode.requestFocus();
    controller.selection = TextSelection.collapsed(offset: controller.text.length);
  }

  void onKey(RawKeyEvent event){
    if(event.runtimeType == RawKeyUpEvent){
      var key = event.logicalKey.keyId;
      switch(key){
        case 44: onComma(null);break;
        default: print(key);
      }
    }
    else if(event.runtimeType == RawKeyDownEvent){
      var key = event.logicalKey.keyId;
      switch(key){
        case 4294967304: onBackPress();break;
        default: print(key);
      }
    }
  }

  void onComma(selection) {
    var text = controller.text.trim();
    if(text.isEmpty){
      return;
    }
    controller.text = "";
    setState(() {
      items.add(text);
      widget.onTagAdded(selection??text);
    });
    onTap();
  }

  void onBackPress() {
    var selection = controller.selection;
    var start = selection.start;
    var end = selection.end;
    if(start<1 && end<1 && items.isNotEmpty){
      setState(() {
        var last = items.last;
        items.removeLast();
        widget.onTagDeleted(last);
      });
    }
  }

  void onDelete(dynamic e) {
    setState(() {
      items.remove(e);
      widget.onTagDeleted(e);
    });
  }

  TextFieldWidget() {
    return TextField(
        decoration: InputDecoration.collapsed(
            hintText: widget.hint
        ),
        focusNode: focusNode,
        controller: controller,
        inputFormatters: widget.inputFormatters?? [
          FilteringTextInputFormatter.allow(RegExp(r"[^,^\s]+[\s]?")),
        ]
    );
  }

  BoxDecoration _defaultFieldDecoration() {
    return BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary)
    );
  }

  BoxConstraints _defaultOptionListConstraints() {
    return BoxConstraints(maxHeight: 200,maxWidth: 200);
  }
}

