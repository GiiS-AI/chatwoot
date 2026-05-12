# GiiS-AI patch: allow Chatwoot to be embedded inside the GiiS platform iframe.
# X-Frame-Options SAMEORIGIN is set by ActionDispatch::ContentSecurityPolicy middleware
# which blocks cross-port iframes. Override to ALLOWALL for local dev.
Rails.application.config.action_dispatch.default_headers.merge!(
  'X-Frame-Options' => 'ALLOWALL'
)
