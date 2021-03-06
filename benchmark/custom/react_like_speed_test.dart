import "package:squares/squares.dart" as react;
import "package:squares/squares_browser.dart" as react;
//import "dart:html";
//import "dart:async";
import "package:logging/logging.dart";
import "package:useful/useful.dart";

Logger logger = new Logger("tiles");

Stopwatch stopwatch = new Stopwatch()..start();
timeprint(message) {
  logger.info("$message ${stopwatch.elapsedMilliseconds}");
  stopwatch.reset();
}


class _Div extends react.Component{

  _Div([props, children]): super(props, children);

  shouldComponentUpdate(nProps, nState) {
    return nProps['key'] != props['key'];
  }

  render() {
    return react.div(props, props['children']);
  }
}

var Div = react.registerComponent(({props, children}) => new _Div(props, children));

class _Span extends react.Component{

  _Span([props, children]): super(props, children);

  shouldComponentUpdate(nProps, nState) {
    return nProps['children'][0] != props['children'][0];
  }

  render() {
    return react.span(props: props, children: props['children']);
  }
}

var Span = react.registerComponent(({props, children}) => new _Span(props, children));

class _Hello extends react.Component {

  _Hello([props, children]): super.withParams(props, children);

  render() {
    timeprint("rendering start");
    List<List<String>> data = props['data'];
    var children = [];
    for (var elem in data) {
      children.add(
          react.div(props: {'class': 'div(${elem[0]})'}, children: [
            react.span(props: {'class': 'inner_span_${elem[0]}'}, children: elem[0]),
            " ",
            react.span(props: {'class': 'inner_span_${elem[0]}'}, children: elem[1])
          ], key: elem[0])
      );
    }
    var res = react.div(props: {}, children: children);
    timeprint("rendering ends");
    return res;
  }
}

var Hello = react.registerComponent(({props, children}) => new _Hello(props, children));

void main() {
  setupDefaultLogHandler();
  stopwatch.reset();
  logger.level = Level.WARNING;

  react.initTilesBrowserConfiguration();
  var data=[];
  for (num i=0; i<1000; i++) {
    data.add(["name_$i", "value_$i"]);
  }
  timeprint("virtual dom building starts");
  react.ComponentDescription h = Hello(props: {"data": data}, children: []);
  react.Node node = new react.Node.fromDescription(null, h);
  for (int i=0; i<100; i++) {
    node.update(force: true);
  }
  logger.level = Level.INFO;
  timeprint("after creating node");
  node.update(force: true);
  timeprint("virtual dom building ends");

//  print("\n\n");
//
//  timeprint("mounting starts");
//  react.mountComponent(Hello({"data": data}, []), querySelector('#content'));
//  timeprint("mounting ends");

//  window.focus();
//  window.close();
}

