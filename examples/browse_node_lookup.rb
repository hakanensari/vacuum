# frozen_string_literal: true

req = Vacuum.new
req.associate_tag = 'foo'
query = {
  'BrowseNodeId' => '283155'
}
res = req.browse_node_lookup(query: query)
res.to_h
