var toggable_input,
 xmlhttp = null,
	xslhttp = null,
	xmlRspn = null,
	xslRspn = null,
	xmlURI_default = "edizione.xml",
	xslURI_default = "testocritico.xsl",
	div_id_default = "testocritico",
	pass = 0,
	pg,
	json = [
	 { "xmlURI" : xmlURI_default,
	   "xslURI" : "apparato.xsl",
	   "div_id" : "apparato" },
	 { "xmlURI" : xmlURI_default,
	   "xslURI" : xslURI_default,
	   "div_id" : div_id_default },
	 { "xmlURI" : xmlURI_default,
	   "xslURI" : "navigazione.xsl",
	   "div_id" : "navigazione" }],
options = {

    // Required. Called when a user selects an item in the Chooser.
    success: function(files) {
     updatePage(files, 1);
    },

    // Optional. Called when the user closes the dialog without selecting a file
    // and does not include any parameters.
    cancel: function() {

    },

    // Optional. "preview" (default) is a preview link to the document for sharing,
    // "direct" is an expiring link to download the contents of the file. For more
    // information about link types, see Link types below.
    linkType: "direct", // or "preview"

    // Optional. A value of false (default) limits selection to a single file, while
    // true enables multiple file selection.
    multiselect: false, // or true

    // Optional. This is a list of file extensions. If specified, the user will
    // only be able to select files with these extensions. You may also specify
    // file types, such as "video" or "images" in the list. For more information,
    // see File types below. By default, all extensions are allowed.
    extensions: ['.xml'],

    // Optional. A value of false (default) limits selection to files,
    // while true allows the user to select both folders and files.
    // You cannot specify `linkType: "direct"` when using `folderselect: true`.
    folderselect: false, // or true

    // Optional. A limit on the size of each file that may be selected, in bytes.
    // If specified, the user will only be able to select files with size
    // less than or equal to this limit.
    // For the purposes of this option, folders have size zero.
    sizeLimit: 20000000, // or any positive number
};

document.addEventListener("DOMContentLoaded", theDomHasLoaded, false);
window.addEventListener("load", pageFullyLoaded, false);

function theDomHasLoaded(e) {
 var button = Dropbox.createChooseButton(options);
 document.getElementById("dropbox_loading").appendChild(button);
 toggable_input = document.getElementById('toggle');
 toggable_input.addEventListener("click",togglehandling,{passive:true});
}

function pageFullyLoaded(e) {
 var bookmark = sessionStorage.getItem('pg');
 if (bookmark>1) {loadEditionPage(bookmark);} else {init(pg, 1);}
}

function togglehandling(pg, i) {
 toggleById("navigazione");
 toggleById("testocritico");
 toggleById("dropbox_loading");
 toggleByTagName("sup");
 toggleByTagName("summary");
 toggleByTagName("details");
}

function init(pg, i) {
	pass++;
	if (pass == 1)
		pg = 1;
 //var obj = json[i];
 //sendRequest(obj.xmlURI, obj.xslURI, obj.div_id, pg, i);
 loadEditionPage(pg);
}

function loadEditionPage(pg) {
     var localEditionLink = localStorage.getItem('edizione');
     if (localEditionLink) {
      updatePageByLink(localEditionLink, pg);
      sessionStorage.setItem('pg', pg);
     }
}

function updatePage(files, pg) {
     updatePageByLink(files[0].link, pg)
}

function updatePageByLink(XMLlink, pg) {
	    xmlhttp = new XMLHttpRequest();
	    if (xmlhttp) {
		    xmlhttp.open("get", XMLlink, true);
		    xmlhttp.send();
		    xmlhttp.onreadystatechange = function() {
			    if (xmlhttp.readyState === 4 && xmlhttp.status == 200) {
				    xmlRspn = xmlhttp.response;
	       localStorage.setItem('edizione', XMLlink);
				    xslhttp = new XMLHttpRequest();
	       if (xslhttp) {
		       xslhttp.open("get", "testocritico.xsl", true);
		       xslhttp.send();
		       xslhttp.onreadystatechange = function() {
			       if (xslhttp.readyState === 4 && xslhttp.status == 200) {
				       xslRspn = xslhttp.response;
	          //sessionStorage.setItem('testocritico',xmlRspn);
				       applyTransform("testocritico", xmlRspn, xslRspn, pg);
			        xslhttp = new XMLHttpRequest();
	          if (xslhttp) {
		          xslhttp.open("get", "apparato.xsl", true);
		          xslhttp.send();
		          xslhttp.onreadystatechange = function() {
			          if (xslhttp.readyState === 4 && xslhttp.status == 200) {
				          xslRspn = xslhttp.response;
	             //sessionStorage.setItem('apparato',xmlRspn);
				          applyTransform("apparato", xmlRspn, xslRspn, pg);
			           xslhttp = new XMLHttpRequest();
	             if (xslhttp) {
		             xslhttp.open("get", "navigazione.xsl", true);
		             xslhttp.send();
		             xslhttp.onreadystatechange = function() {
			             if (xslhttp.readyState === 4 && xslhttp.status == 200) {
				             xslRspn = xslhttp.response;
	                //sessionStorage.setItem('navigazione',xmlRspn);
				             applyTransform("navigazione", xmlRspn, xslRspn, pg);
			             }
		             };
			           }
			          }
		          };
			        }
			       }
		       };
			     }
		     };
	     }
	    }
}

function sendRequest(xmlURL, xslURL, div_id, pg, i) {
 var sessionXMLstring = sessionStorage.getItem(div_id);
	if (sessionXMLstring) {
	 parser = new DOMParser();
	 xmlRspn = parser.parseFromString(sessionXMLstring,"text/xml");
		xslhttp = new XMLHttpRequest();
	 if (xslhttp) {
	  xslhttp.open("get", xslURL, true);
	  xslhttp.send();
	  xslhttp.onreadystatechange = function() {
	   if (xslhttp.readyState === 4 && xslhttp.status == 200) {
	    xslRspn = parser.parseFromString(xslhttp.response,"text/xml");
			  applyTransform(div_id, xmlRspn, xslRspn, pg);
			  }
		  };
			}
	} else {
	 xmlhttp = new XMLHttpRequest();
 	if (xmlhttp) {
 		xmlhttp.open("get", xmlURL, true);
 		xmlhttp.send();
 		xmlhttp.onreadystatechange = function() {
 			if (xmlhttp.readyState === 4 && xmlhttp.status == 200) {
 				xmlRspn = xmlhttp.response;
 				xslhttp = new XMLHttpRequest();
 	   if (xslhttp) {
 		   xslhttp.open("get", xslURL, true);
 		   xslhttp.send();
 		   xslhttp.onreadystatechange = function() {
 			   if (xslhttp.readyState === 4 && xslhttp.status == 200) {
 				   xslRspn = xslhttp.response;
 				   doTrnsfrmGcko(div_id, xmlRspn, xslRspn, pg, i);
 			   }
 		   };
 			 }
 		 };
 	 } 
 	}
	}
}

function doTrnsfrmGcko(docelement, xmlDoc, xslDoc, pg, i) {
	if (xmlDoc == null || xslDoc == null) return;
	else {
	 var xsltProcessor = new XSLTProcessor();
		 xsltProcessor.importStylesheet(xslDoc);
		 xsltProcessor.setParameter(null, "crrntPag", pg);
		 var fragment = xsltProcessor.transformToFragment(xmlDoc, document);
		 document.getElementById(docelement).innerHTML = "";
		 document.getElementById(docelement).appendChild(fragment);
	 if (i == 1) {
		 MathJax.typeset();
		 init(pg, 0);}
		else if (i == 0) {
		 MathJax.typeset();
		 init(pg, 2);}
		else if (i == 2) { }
	}
	document.getElementById('toggle').value = sessionStorage.getItem('pg')
}

function toggleById (index_id) {
 var index_element = document.getElementById(index_id);
 index_element.classList.toggle("hidden");
 index_element.classList.toggle("visible");
}

function toggleByTagName (index_name) {
 var index_elements = document.getElementsByTagName(index_name);
 for (one=0;one<index_elements.length;one++) { 
  index_elements[one].classList.toggle("hidden");
  index_elements[one].classList.toggle("visible");
 }
}

function applyTransform(div_id, xmlDoc, xslDoc, pg) {
	if (xmlDoc == null || xslDoc == null) return;
	else {
	  var xsltProcessor = new XSLTProcessor(), 
	  parser = new DOMParser(), 
	  fragment = new DocumentFragment();
	  xslDocParsed = parser.parseFromString(xslDoc,"text/xml");
	  xsltProcessor.importStylesheet(xslDocParsed);
		 xsltProcessor.setParameter(null,"crrntPag",pg);
		 xmlDocParsed = parser.parseFromString(xmlDoc,"text/xml");
		 fragment = xsltProcessor.transformToFragment(xmlDocParsed, document);
		 if (fragment == null) {return;} else {
		 document.getElementById(div_id).innerHTML = "";
		 document.getElementById(div_id).appendChild(fragment); MathJax.typeset(); }
	}
	document.getElementById('toggle').value = sessionStorage.getItem('pg')
}
