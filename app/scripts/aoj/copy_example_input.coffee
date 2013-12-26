data = ""
tags = [
  {
    name: "p"
    type: HTMLParagraphElement
  }
  {
    name: "div"
    type: HTMLDivElement
  }
  {
    name: "h2"
    type: HTMLHeadingElement
  }
  {
    name: "h3"
    type: HTMLHeadingElement
  }
]

tags.forEach (tag)->
  elements = document.getElementsByTagName tag.name
  for element in elements
    next_element = element.nextElementSibling
    continue unless next_element
    continue unless element.childNodes.length == 1

    unless next_element instanceof HTMLPreElement
      if next_element.children.length >= 1 && next_element.children[0] instanceof HTMLPreElement
        next_element = next_element.children[0]

    # 入力の直前にあるヘッダを探す
    text = element.innerText
    # 出力にマッチしない
    unless text.indexOf("出力") == -1 && text.indexOf("Output") == -1
      continue
    # 入力にマッチする
    unless text.indexOf("入力") != -1 || text.indexOf("Input") != -1
      continue

    if next_element instanceof HTMLPreElement
      if next_element.childNodes.length >= 1 && next_element.childNodes[0] instanceof Text
        text = next_element.innerText
        unless text.match /[\r\n]$/
          text += "\n"
        data += text

chrome.extension.sendMessage
  type: "copy"
  data: data

