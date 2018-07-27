# Flatten an array of host structures to an array of strings.
#
# @param hosts The array of hosts to flatten, `undef` is passed through.
#
# @return [Optional[Array[String, 1]]] The array of flattened strings.
#
# @example
#   postfix::flatten_host(['2001:db8::1', ['192.0.2.1', 389]])
#
# @since 2.0.0
function postfix::flatten_host(Optional[Array[Variant[Postfix::Type::Lookup::LDAP::Host, Postfix::Type::Lookup::MySQL::Host, Postfix::Type::Lookup::PgSQL::Host], 1]] $hosts) {

  $hosts ? {
    undef   => undef,
    default => $hosts.map |$x| {
      type($x) ? {
        Type[Tuple]           => join($x.map |$y| {
          type($y) ? {
            Type[Bodgitlib::Host] => bodgitlib::enclose_ipv6($y), # lint:ignore:unquoted_string_in_selector FIXME
            default               => $y,
          }
        }, ':'),
        Type[Bodgitlib::Host] => bodgitlib::enclose_ipv6($x), # lint:ignore:unquoted_string_in_selector FIXME
        default               => $x,
      }
    },
  }
}
