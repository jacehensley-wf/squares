part of squares;

const _VALUE = "value";

class TextareaComponent extends DomComponent {

  TextareaComponent(Map props):
    super(props: props, tagName: "textarea");

  render() => null;
}

ComponentFactory _textareaFactory = ({Map props, children}) => new TextareaComponent(props);

class CustomComponent extends DomComponent {
  CustomComponent(Map props): super(props: props);
}
