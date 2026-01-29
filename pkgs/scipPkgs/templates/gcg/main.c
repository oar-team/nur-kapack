#include <scip/scip.h>
#include <gcg/gcg.h>
#include <gcg/gcgplugins.h>

SCIP_RETCODE run()
{
  SCIP *scip = NULL;

  SCIP_CALL(SCIPcreate(&scip));

  SCIP_CALL(SCIPincludeGcgPlugins(scip));

  GCGprintVersion(scip, NULL);
  SCIPinfoMessage(scip, NULL, "\n");

  SCIPprintVersion(scip, NULL);
  SCIPinfoMessage(scip, NULL, "\n");

  SCIPprintExternalCodes(scip, NULL);
  SCIPinfoMessage(scip, NULL, "\n");

  // do some stuff...

  SCIP_CALL(SCIPfree(&scip));

  BMScheckEmptyMemory();

  return SCIP_OKAY;
}

int main(int argc, char const *argv[])
{
  SCIP_RETCODE retcode = run();

  if (retcode != SCIP_OKAY)
  {
    SCIPprintError(retcode);
    return -1;
  }

  return 0;
}
