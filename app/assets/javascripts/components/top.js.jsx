class Top extends React.Component {
  render() {
    return (
      <div>
        <h1>{this.props.title}</h1>
        <p>{this.props.env}</p>
      </div>
    )
  }
}
