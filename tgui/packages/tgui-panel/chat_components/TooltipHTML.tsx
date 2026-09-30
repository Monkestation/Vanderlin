/**
 * @file
 * @license MIT
 */

import { sanitizeHTML } from 'tgui/sanitize';
import { Tooltip } from 'tgui-core/components';

interface TooltipHTMLProps extends React.ComponentProps<typeof Tooltip> {
  html: string;
}

/**
 * I shouldn't have to say why this is dangerous to use.
 */
export const TooltipHTML = (props: TooltipHTMLProps) => {
  const { html, content, ...rest } = props;
  const sanitized = sanitizeHTML(html);
  const unsafeContent = (
    // eslint-disable-next-line react/no-danger
    <div dangerouslySetInnerHTML={{ __html: sanitized }} />
  );
  return <Tooltip content={unsafeContent} {...rest} />;
};
