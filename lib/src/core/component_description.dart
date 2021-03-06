part of squares;

class ComponentDescription {
  ComponentFactory factory;

  dynamic props;

  List<ComponentDescription> children = [];

  dynamic key;

  Map listeners;

  /**
   * default constructor which only set final vars.
   */
  ComponentDescription(ComponentFactory this.factory, {this.props, this.children, this.key, this.listeners});

  /**
   * creates component by factory with props.
   */
  Component createComponent() => this.factory(props: this.props, children: this.children);

  ComponentDescription call(dynamic c) {
    if (this.children == null) {
      this.children = [];
    }
    this.children.addAll(_processChildren(c));
    return this;
  }

  dynamic noSuchMethod(Invocation i) {
    if ((i.memberName == #call) && (i.isMethod)) {
      if (this.children == null) {
        this.children = [];
      }
      if (i.positionalArguments != null) {
        this.children.addAll(_processChildren(i.positionalArguments));
      } else {
      }
      return this;
    }

    return super.noSuchMethod(i);
  }
}
