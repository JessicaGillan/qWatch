var doStuffWithDOM = function doStuffWithDOM(a, e, i, o, u){
  console.log("called")
  console.log(a, e, i, o, u)
}

  chrome.tabs.sendMessage(tab.id, { text: "report_back" },
                          doStuffWithDOM);
