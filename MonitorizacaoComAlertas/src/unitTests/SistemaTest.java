import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

import medicao.Sistema;

class SistemaTest {

	@Test
	void test() {
		Sistema sis = new Sistema (0,20,0,300,0.5,0.5,0.5,0.5, 15);
		assertEquals(sis.getLimiteInferiorTemperatura()==0,true);
		assertEquals(sis.getLimiteSuperiorTemperatura()==20,true);
		assertEquals(sis.getLimiteInferiorLuz()==0,true);
		assertEquals(sis.getLimiteSuperiorLuz()==300,true);
		assertEquals(sis.getPercentagemVariacaoTemperatura()==0.5,true);
		assertEquals(sis.getPercentagemVariacaoLuz()==0.5,true);
		assertEquals(sis.getMargemSegurancaLuz()==0.5,true);
		assertEquals(sis.getMargemSegurancaTemperatura()==0.5,true);
		assertEquals(sis.getTempoEntreAlertasConsecutivos()==15,true);
		
	}

}
