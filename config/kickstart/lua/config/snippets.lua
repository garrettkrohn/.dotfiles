local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets('lua', {
  s('hello', {
    t 'print(hello world)',
  }),
})

ls.add_snippets('javascript', {
  s('cl', {
    t 'console.log(',
    i(1),
    t ')',
  }),
})

ls.add_snippets('java', {
  s('test', {
    t { '@Test', '@DisplayName("' },
    i(1),
    t { '")', 'public void test_' },
    i(2),
    t { '() {', '//arrange', '', '//act', '', '//assert', '}' },
  }),
})

ls.add_snippets('python', {
  s('testfile', {
    t {
      'import unittest',
      'from unittest.mock import patch, MagicMock, call',
      'import os',
      'import json',
      'import logging',
      '',
      'log = logging.getLogger(__name__)',
      'logging.basicConfig(level=logging.INFO)',
      '',
      'class Test',
    },
    i(1),
    {
      '(unittest.TestCase):',
      '',
      '    def test_',
    },
    i(2),
    {
      '(self):',
      '        self.assertEqual(1,1)',
      '',
      '',
      "if __name__ == '__main__':",
      '    unittest.main()',
    },
  }),
})

ls.add_snippets('python', {
  s('test', {
    t {

      '    def test_',
    },
    i(1),
    {

      '(self):',
      '        self.assertEqual(1,1)',
    },
  }),
})

--
--
--
--
-- @Test
-- @DisplayName("processASNsByClient")
-- public void test_processASNsByClient() throws Exception {
--     long clientId = 1L;
--     //mocks for processASNsByClient
--     when(commonUtilService.getUserId()).thenReturn(1L);
--
--     //mocks for removeDomainDisassociatedClientASNs
--     List<AsnClientDto> asnClientDtoList = getAsnClientDtoList();
--     when(asnClientRepository.findAllASNsToRemove(clientId)).thenReturn(asnClientDtoList);
--
--     List<Long> portIdsToDescope = List.of(1L,2L,3L);
--     when(portRepository.getPortIdsWithinIpRange(clientId, "1.1.1.1", "1.1.1.9")).thenReturn(portIdsToDescope);
--
--     List<List<Long>> listOfLists = new ArrayList<>();
--     listOfLists.add(portIdsToDescope);
--     ListUtilsWrapper listUtilsWrapper = mock(ListUtilsWrapper.class);
--     when(listUtilsWrapper.partition(portIdsToDescope, 500)).thenReturn(listOfLists);
--
--     when(portRepository.updateMonitoredForPorts(false, portIdsToDescope, 1L, 1L, 1L)).thenReturn(1);
--
--     //mocks for removeExpiredClientASNRanges
--     List<Long> longList = List.of(1L, 2L);
--     when(asnClientRepository.descopeIpFromExpiredClientASNs(1L, 1L, 1L)).thenReturn(longList);
--     when(asnClientRepository.removeExpiredClientASNs(1L)).thenReturn(1);
--
--     //mocks for insertNEwASNsByDomain
--
--
--
--     // act
--     asnService.processASNsByClient(1L, true, 1L, 1L);
--
--
--     //verify removeDomainDisassociatedClientASNs
--     verify(asnClientRepository, times(1)).deleteAsnClient(any());
--     verify(asnClientRepository, times(1)).descopeIpFromExpiredClientASNs(any(), any(), any());
--     verify(asnClientRepository, times(1)).removeExpiredClientASNs(any());
--
-- }
