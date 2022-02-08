import React from 'react';
import ReactDOMServer from 'react-dom/server';

export class ReactUtil {
  static linkAsText = (url, urlText) => {
    return ReactDOMServer.renderToString(
      <a
        href = { url }
        target = '_blank'
        rel = 'noopener noreferrer'
      >
        { urlText }
      </a>
    );
  };

  static phoneNumAsText = (telNumber, telNumberText) => {
    return ReactDOMServer.renderToString(
      <a
        href = { 'tel:' + telNumber }
        rel = 'noopener noreferrer'
      >
        { telNumberText }
      </a>
    );
  };
}
